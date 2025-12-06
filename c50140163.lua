--魅惑の女王 LV7
local s,id,o=GetID()
function c50140163.initial_effect(c)
	aux.AddCodeList(c,23756165)
	--flag effect id+1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c50140163.regop)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50140163,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCondition(c50140163.eqcon1)
	e2:SetTarget(c50140163.eqtg)
	e2:SetOperation(c50140163.eqop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(c50140163.eqcon2)
	c:RegisterEffect(e3)
end
c50140163.lvup={23756165}
c50140163.lvdn={23756165,87257460}
function c50140163.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetSpecialSummonInfo(SUMMON_INFO_CODE)==23756165 then
		c:RegisterFlagEffect(id+1,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end
function c50140163.eqcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(id+1)>0 and not aux.IsSelfEquip(c,FLAG_ID_ALLURE_QUEEN) and not aux.IsCanBeQuickEffect(c,tp,95937545)
end
function c50140163.eqcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(id+1)>0 and not aux.IsSelfEquip(c,FLAG_ID_ALLURE_QUEEN) and aux.IsCanBeQuickEffect(c,tp,95937545)
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
end
function c50140163.eqlimit(e,c)
	return e:GetOwner()==c
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
		tc:RegisterFlagEffect(FLAG_ID_ALLURE_QUEEN,RESET_EVENT+RESETS_STANDARD,0,0,id)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
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
