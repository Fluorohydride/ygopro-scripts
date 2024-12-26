--武神－トリフネ
---@param c Card
function c29981935.initial_effect(c)
	--sp summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29981935,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,29981935)
	e1:SetCost(c29981935.spcost)
	e1:SetTarget(c29981935.sptg)
	e1:SetOperation(c29981935.spop)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29981935,1))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,29981936)
	e2:SetCondition(c29981935.eqcon)
	e2:SetTarget(c29981935.eqtg)
	e2:SetOperation(c29981935.eqop)
	c:RegisterEffect(e2)
end
function c29981935.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c29981935.spfilter(c,e,tp)
	return c:IsSetCard(0x88) and not c:IsCode(29981935) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c29981935.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c29981935.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		return Duel.GetMZoneCount(tp,e:GetHandler())>=2 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
			and g:GetClassCount(Card.GetRace)>=2
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c29981935.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetMatchingGroup(c29981935.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,aux.drccheck,false,2,2)
	if sg then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c29981935.eqfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsSetCard(0x88) and c:IsType(TYPE_XYZ) and c:IsSummonType(SUMMON_TYPE_XYZ)
end
function c29981935.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c29981935.eqfilter,1,nil,tp)
end
function c29981935.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	local tg
	if #eg==1 then
		tg=eg:Clone()
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		tg=eg:FilterSelect(tp,c29981935.eqfilter,1,1,nil,e,tp)
	end
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c29981935.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown() or not tc:IsRelateToEffect(e) or not c:CheckUniqueOnField(tp) then
		return
	end
	Duel.Equip(tp,c,tc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c29981935.eqlimit)
	e1:SetLabelObject(tc)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_BATTLE_DESTROY_REDIRECT)
	e2:SetValue(LOCATION_REMOVED)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
end
function c29981935.eqlimit(e,c)
	return c==e:GetLabelObject()
end
