--機動要塞 メタル・ホールド
function c42237854.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c42237854.target)
	e1:SetOperation(c42237854.activate)
	c:RegisterEffect(e1)
	--atk limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(c42237854.atlimit)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SELECT_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,0xff)
	e3:SetValue(c42237854.tgtg)
	c:RegisterEffect(e3)
end
function c42237854.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:GetLevel()==4
end
function c42237854.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c42237854.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c42237854.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,42237854,0,0x21,0,0,4,RACE_MACHINE,ATTRIBUTE_EARTH) end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c42237854.filter,tp,LOCATION_MZONE,0,1,ft,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,g:GetCount(),0,0)
end
function c42237854.tgfilter(c,e)
	return c:IsFaceup() and c:IsRelateToEffect(e)
end
function c42237854.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,42237854,0,0x21,0,0,4,RACE_MACHINE,ATTRIBUTE_EARTH) then return end
	c:AddMonsterAttribute(0,0,0,0,0)
	Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c42237854.atkval)
	c:RegisterEffect(e1)
	c:TrapMonsterComplete(TYPE_EFFECT)
	Duel.SpecialSummonComplete()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c42237854.tgfilter,nil,e)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if g:GetCount()<=0 or ft<=0 then return end
	local tg=nil
	if ft<g:GetCount() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		tg=g:FilterSelect(tp,c42237854.filter,ft,ft,nil)
	else
		tg=g:Clone()
	end
	if tg:GetCount()>0 then
		Duel.BreakEffect()
		local tc=tg:GetFirst()
		while tc do
			Duel.Equip(tp,tc,c,false,true)
			tc:RegisterFlagEffect(42237854,RESET_EVENT+0x1fe0000,0,0)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c42237854.eqlimit)
			tc:RegisterEffect(e1,true)
			tc=tg:GetNext()
		end
		Duel.EquipComplete()
	end
end
function c42237854.atkval(e,c)
	local atk=0
	local g=c:GetEquipGroup()
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(42237854)~=0 and tc:GetAttack()>=0 then
			atk=atk+tc:GetAttack()
		end
		tc=g:GetNext()
	end
	return atk
end
function c42237854.eqlimit(e,c)
	return e:GetOwner()==c
end
function c42237854.atlimit(e,c)
	return c~=e:GetHandler()
end
function c42237854.tgtg(e,re,c)
	return c~=e:GetHandler() and c:IsControler(e:GetHandlerPlayer()) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup()
end
