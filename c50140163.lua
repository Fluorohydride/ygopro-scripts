--魅惑の女王 LV7
function c50140163.initial_effect(c)
	aux.AddCodeList(c,23756165)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c50140163.regop)
	c:RegisterEffect(e1)
end
c50140163.lvup={23756165}
c50140163.lvdn={23756165,87257460}
function c50140163.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_LV or (re and re:GetHandler():IsCode(23756165)) then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(50140163,0))
		e1:SetCategory(CATEGORY_EQUIP)
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1)
		e1:SetCondition(c50140163.eqcon1)
		e1:SetTarget(c50140163.eqtg)
		e1:SetOperation(c50140163.eqop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetLabelObject(e)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetType(EFFECT_TYPE_QUICK_O)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetCondition(c50140163.eqcon2)
		c:RegisterEffect(e2)
	end
end
function c50140163.eqcon1(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetLabelObject():GetLabelObject()
	return (ec==nil or ec:GetFlagEffect(50140163)==0) and not Duel.IsPlayerAffectedByEffect(tp,95937545)
end
function c50140163.eqcon2(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetLabelObject():GetLabelObject()
	return (ec==nil or ec:GetFlagEffect(50140163)==0) and Duel.IsPlayerAffectedByEffect(tp,95937545)
end
function c50140163.filter(c)
	return c:IsAbleToChangeControler()
end
function c50140163.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c50140163.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c50140163.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c50140163.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c50140163.eqlimit(e,c)
	return e:GetOwner()==c and not c:IsDisabled()
end
function c50140163.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local atk=tc:GetTextAttack()
		local def=tc:GetTextDefense()
		if atk<0 then atk=0 end
		if def<0 then def=0 end
		if not Duel.Equip(tp,tc,c,false) then return end
		--Add Equip limit
		tc:RegisterFlagEffect(50140163,RESET_EVENT+RESETS_STANDARD,0,0)
		e:GetLabelObject():SetLabelObject(tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c50140163.eqlimit)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_SET_AVAILABLE)
		e2:SetCode(EFFECT_DESTROY_SUBSTITUTE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(c50140163.repval)
		tc:RegisterEffect(e2)
	end
end
function c50140163.repval(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
