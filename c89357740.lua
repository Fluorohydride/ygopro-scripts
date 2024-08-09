--ユニオン・パイロット
local s,id,o=GetID()
function s.initial_effect(c)
	aux.EnableUnionAttribute(c,s.eqfilter)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.recost)
	e1:SetTarget(s.retg)
	e1:SetOperation(s.reop)
	c:RegisterEffect(e1)
end
s.has_text_type=TYPE_UNION
function s.eqfilter(c)
	return c:IsType(TYPE_EFFECT)
end
function s.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHandAsCost() end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
end
function s.tgfilter(c,e,tp)
	local exct=aux.IsUnionState(e) and 1 or 0
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsControler(tp)
		and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_REMOVED,0,1,nil,c,tp,exct)
end
function s.cfilter(c,ec,tp,exclude_modern_count)
	return c:IsFaceup() and c:IsType(TYPE_UNION)
		and c:CheckUniqueOnField(tp) and not c:IsForbidden() and c:CheckUnionTarget(ec) and aux.CheckUnionEquip(c,ec,exclude_modern_count)
end
function s.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPE_EFFECT+TYPE_MONSTER,2100,1000,5,RACE_MACHINE,ATTRIBUTE_LIGHT)
		and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.SetTargetCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_REMOVED)
end
function s.reop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local sg=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_REMOVED,0,1,1,nil,tc,tp)
		local ec=sg:GetFirst()
		if ec and Duel.Equip(tp,ec,tc) then
			aux.SetUnionState(ec)
			if e:GetHandler():IsRelateToChain() and e:GetHandler():IsLocation(LOCATION_HAND) then
				Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end