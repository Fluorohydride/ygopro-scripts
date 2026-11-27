--No.4 猛毒刺胞ステルス・クラーゲン
function c67557908.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),4,2)
	c:EnableReviveLimit()
	--attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsFaceup))
	e1:SetValue(ATTRIBUTE_WATER)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67557908,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCondition(c67557908.descon)
	e2:SetTarget(c67557908.destg)
	e2:SetOperation(c67557908.desop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67557908,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c67557908.spcon)
	e3:SetTarget(c67557908.sptg)
	e3:SetOperation(c67557908.spop)
	c:RegisterEffect(e3)
end
aux.xyz_number[67557908]=4
function c67557908.descon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c67557908.desfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c67557908.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67557908.desfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c67557908.desfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c67557908.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c67557908.desfilter,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	Duel.HintSelection(g)
	local dam=math.floor(tc:GetAttack()/2)
	if Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Damage(1-tp,dam,REASON_EFFECT)
	end
end
function c67557908.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetPreviousOverlayCountOnField()
	e:SetLabel(ct)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_XYZ) and ct>0
end
function c67557908.spfilter(c,e,tp)
	return c:IsCode(94942656) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67557908.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ)>0
		and Duel.IsExistingMatchingCard(c67557908.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c67557908.matfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsCanOverlay()
end
function c67557908.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ)
	if ft<=0 then return end
	ft=math.min(ft,e:GetLabel())
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if ect~=nil then ft=math.min(ft,ect) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c67557908.spfilter,tp,LOCATION_EXTRA,0,1,ft,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_MZONE)
		local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c67557908.matfilter),tp,LOCATION_GRAVE,0,nil)
		local res=false
		local tc=og:GetFirst()
		while tc do
			if sg:GetCount()==0 then return end
			if Duel.SelectEffectYesNo(tp,tc,aux.Stringid(67557908,2)) then
				if res==false then
					res=true
					Duel.BreakEffect()
				end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				local tg=sg:Select(tp,1,1,nil)
				Duel.Overlay(tc,tg)
				sg:Sub(tg)
			end
			tc=og:GetNext()
		end
	end
end
