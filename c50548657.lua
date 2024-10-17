--プロンプトホーン
---@param c Card
function c50548657.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50548657,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,50548657)
	e1:SetCost(c50548657.spcost)
	e1:SetTarget(c50548657.sptg)
	e1:SetOperation(c50548657.spop)
	c:RegisterEffect(e1)
end
function c50548657.costfilter(c,e,tp,g,ft)
	local lv=c:GetLevel()
	return c:IsLevelBelow(4) and c:IsRace(RACE_CYBERSE) and Duel.GetMZoneCount(tp,c)>0 and (c:IsControler(tp) or c:IsFaceup())
		and g:CheckWithSumEqual(Card.GetLevel,lv,1,ft+1)
end
function c50548657.spfilter(c,e,tp)
	return c:IsRace(RACE_CYBERSE) and c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c50548657.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c50548657.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroup(tp,c50548657.costfilter,1,nil,e,tp,g,ft) end
	local sg=Duel.SelectReleaseGroup(tp,c50548657.costfilter,1,1,nil,e,tp,g,ft)
	e:SetLabel(sg:GetFirst():GetLevel())
	Duel.Release(sg,REASON_COST)
end
function c50548657.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c50548657.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c50548657.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if ft<=0 or g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectWithSumEqual(tp,Card.GetLevel,e:GetLabel(),1,ft)
	if sg:GetCount()>0 then
		local fid=e:GetHandler():GetFieldID()
		local tc=sg:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			tc:RegisterFlagEffect(50548657,RESET_EVENT+RESETS_STANDARD,0,1,fid)
			tc=sg:GetNext()
		end
		Duel.SpecialSummonComplete()
		sg:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(sg)
		e1:SetCondition(c50548657.rmcon)
		e1:SetOperation(c50548657.rmop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c50548657.rmfilter(c,fid)
	return c:GetFlagEffectLabel(50548657)==fid
end
function c50548657.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c50548657.rmfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c50548657.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c50548657.rmfilter,nil,e:GetLabel())
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
end
