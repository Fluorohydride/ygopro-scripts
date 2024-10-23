--クロス・オーバー
function c53241226.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,53241226+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c53241226.target)
	e1:SetOperation(c53241226.activate)
	c:RegisterEffect(e1)
end
function c53241226.eqfilter(c)
	return c:IsFaceup() and c:IsAbleToChangeControler()
end
function c53241226.tgfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR)
end
function c53241226.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local ct=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE) then ct=ct-1 end
	if chk==0 then return ct>0
		and Duel.IsExistingTarget(c53241226.eqfilter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingTarget(c53241226.tgfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectTarget(tp,c53241226.eqfilter,tp,0,LOCATION_MZONE,1,1,nil)
	e:SetLabelObject(g:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	Duel.SelectTarget(tp,c53241226.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c53241226.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local hc=g:GetFirst()
	if hc==tc then hc=g:GetNext() end
	if hc:IsControler(tp) and tc:IsFaceup() and tc:IsRelateToEffect(e)
		and tc:IsControler(1-tp) and tc:IsLocation(LOCATION_MZONE)
		and tc:IsAbleToChangeControler() and Duel.Equip(tp,tc,hc,false) then
		--Add Equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(hc)
		e1:SetValue(c53241226.eqlimit)
		tc:RegisterEffect(e1,true)
		--substitute
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_DESTROY_SUBSTITUTE)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(c53241226.desrepval)
		tc:RegisterEffect(e2,true)
		--damage 0
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_NO_BATTLE_DAMAGE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		hc:RegisterEffect(e3,true)
	end
end
function c53241226.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c53241226.desrepval(e,re,r,rp)
	return r&(REASON_BATTLE|REASON_EFFECT)~=0
end
