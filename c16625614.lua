--ダーク・サンクチュアリ
function c16625614.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--update effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c16625614.chcon1)
	e2:SetOperation(c16625614.chop1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_ACTIVATING)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c16625614.chcon2)
	e3:SetOperation(c16625614.chop2)
	c:RegisterEffect(e3)
	--negate attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCategory(CATEGORY_COIN)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(c16625614.condition)
	e4:SetTarget(c16625614.target)
	e4:SetOperation(c16625614.operation)
	c:RegisterEffect(e4)
end
c16625614.toss_coin=true
function c16625614.chcon1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsControler(tp) and rc:IsCode(94212438) and re:GetLabel()==94212438
end
function c16625614.chop1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():RegisterFlagEffect(16625614,RESET_EVENT+0x1fe0000+RESET_CHAIN,0,1)
end
function c16625614.chcon2(e,tp,eg,ep,ev,re,r,rp)
	return ev==1 and e:GetHandler():GetFlagEffect(16625614)>0
end
function c16625614.chop2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.ChangeChainOperation(1,c16625614.dbop)
end
function c16625614.dbop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ids={31893528,67287533,94772232,30170981}
	local id=ids[c:GetFlagEffect(94212438)+1]
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(94212438,1))
	local g=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,id)
	local tc=g:GetFirst()
	if tc and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,0x11,0,0,1,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP,tp,181)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.SelectYesNo(tp,aux.Stringid(16625614,0)) then
		tc:AddMonsterAttribute(TYPE_NORMAL,ATTRIBUTE_DARK,RACE_FIEND,1,0,0)
		Duel.SpecialSummonStep(tc,181,tp,tp,true,false,POS_FACEUP)
		tc:AddMonsterAttributeComplete()
		--immune
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e7:SetRange(LOCATION_MZONE)
		e7:SetCode(EFFECT_IMMUNE_EFFECT)
		e7:SetValue(c16625614.efilter)
		e7:SetReset(RESET_EVENT+0x47c0000)
		tc:RegisterEffect(e7)
		--cannot be target
		local e8=Effect.CreateEffect(c)
		e8:SetType(EFFECT_TYPE_SINGLE)
		e8:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
		e8:SetReset(RESET_EVENT+0x47c0000)
		tc:RegisterEffect(e8)
		Duel.SpecialSummonComplete()
		c:RegisterFlagEffect(94212438,RESET_EVENT+0x1fe0000,0,0)
	elseif tc and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		c:RegisterFlagEffect(94212438,RESET_EVENT+0x1fe0000,0,0)
	end
end
function c16625614.efilter(e,te)
	local tc=te:GetHandler()
	return not tc:IsCode(94212438)
end
function c16625614.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c16625614.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c16625614.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetAttacker()
	local coin=Duel.TossCoin(tp,1)
	if coin==1 then
		if Duel.NegateAttack() then
			Duel.Damage(1-tp,math.ceil(tc:GetAttack()/2),REASON_EFFECT)
		end
	end
end
