--サクリファイス・フュージョン
function c78063197.initial_effect(c)
	--Activate
	local e1=aux.AddFusionEffectProc(c,aux.FilterBoolFunction(Card.IsSetCard,0x1110),LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,Card.IsAbleToRemove,aux.FMaterialRemove)
	e1:SetCountLimit(1,78063197)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(78063197,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,78063198)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c78063197.eqtg)
	e2:SetOperation(c78063197.eqop)
	c:RegisterEffect(e2)
end
function c78063197.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsAbleToChangeControler()
end
function c78063197.eqfilter(c)
	local m=_G["c"..c:GetCode()]
	return c:IsFaceup() and ((c:IsSetCard(0x1110) and c:IsType(TYPE_FUSION)) or c:IsCode(64631466))
		and not c:IsDisabled() and m.can_equip_monster and m.can_equip_monster(c)
end
function c78063197.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c78063197.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c78063197.filter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c78063197.eqfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c78063197.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c78063197.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc1=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c78063197.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
		local tc2=g:GetFirst()
		local m=_G["c"..tc2:GetCode()]
		if tc1:IsFaceup() and tc1:IsRelateToEffect(e) and tc1:IsControler(1-tp) and tc2 then
			m.equip_monster(tc2,tp,tc1)
		end
	end
end
