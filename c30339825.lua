--万物の始源-「水」
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target(nil))
	e1:SetOperation(s.activate(nil))
	c:RegisterEffect(e1)
	--destroy and spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.target(ATTRIBUTE_WATER))
	e2:SetOperation(s.activate(ATTRIBUTE_WATER))
	c:RegisterEffect(e2)
end
function s.spfilter(c,e,tp,att)
	if att and not c:IsAttribute(ATTRIBUTE_WATER) then return false end
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,c:GetOwner())
		and Duel.IsExistingMatchingCard(s.desfilter,c:GetOwner(),LOCATION_MZONE,0,1,nil,c:GetOwner(),att,tp)
end
function s.desfilter(c,p,att,rp)
	if not att and not c:IsAttribute(ATTRIBUTE_WATER) then return false end
	return c:IsFaceup() and Duel.GetMZoneCount(p,c,rp)>0
end
function s.target(att)
	return function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
			if chkc then return chkc:IsLocation(LOCATION_GRAVE) and s.spfilter(chkc,e,tp,att) end
			if chk==0 then return Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp,att) end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp,att)
			local gc=g:GetFirst()
			local dg=Duel.GetFieldGroup(gc:GetOwner(),LOCATION_MZONE,0)
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,1,0,0)
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
		end
end
function s.activate(att)
	return function(e,tp,eg,ep,ev,re,r,rp)
			local tc=Duel.GetFirstTarget()
			if not tc:IsRelateToEffect(e) then return end
			local sp=tc:GetOwner()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,s.desfilter,sp,LOCATION_MZONE,0,1,1,nil,sp,att,tp)
			if g then
				Duel.HintSelection(g)
				if Duel.Destroy(g,REASON_EFFECT)~=0 and aux.NecroValleyFilter()(tc) then
					Duel.SpecialSummon(tc,0,tp,sp,false,false,POS_FACEUP_DEFENSE)
				end
			end
		end
end
