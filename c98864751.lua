--エアークラック・ストーム
function c98864751.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c98864751.target)
	e1:SetOperation(c98864751.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetValue(c98864751.eqlimit)
	c:RegisterEffect(e2)
	--extra attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98864751,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c98864751.drcon)
	e3:SetCost(c98864751.cost)
	e3:SetOperation(c98864751.drop)
	c:RegisterEffect(e3)
	if not c98864751.global_check then
		c98864751.global_check=true
		c98864751[0]=0
		c98864751[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(c98864751.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c98864751.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c98864751.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc:GetFlagEffect(98864751)==0 then
		c98864751[ep]=c98864751[ep]+1
		tc:RegisterFlagEffect(98864751,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c98864751.clear(e,tp,eg,ep,ev,re,r,rp)
	c98864751[0]=0
	c98864751[1]=0
end
function c98864751.eqlimit(e,c)
	return c:IsRace(RACE_MACHINE)
end
function c98864751.eqfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c98864751.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c98864751.eqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98864751.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c98864751.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c98864751.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c98864751.drcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	return e:GetHandler():GetEquipTarget()==ec and ec:GetBattleTarget():IsReason(REASON_BATTLE)
end
function c98864751.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c98864751[tp]==0 or c:GetEquipTarget():GetFlagEffect(98864751)~=0 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_OATH+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c98864751.ftarget)
	e1:SetLabel(c:GetEquipTarget():GetFieldID())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c98864751.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function c98864751.drop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
	e:GetHandler():GetEquipTarget():RegisterEffect(e1)
end
