--Coordius the Triphasic Dealmon
function c70219023.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,false,true,c70219023.fusfilter1,c70219023.fusfilter2,c70219023.fusfilter3)
	--reg
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCondition(c70219023.regcon)
	e1:SetOperation(c70219023.regop)
	c:RegisterEffect(e1)
end
c70219023.material_type=TYPE_SYNCHRO
function c70219023.fusfilter1(c)
	return c:IsFusionType(TYPE_SYNCHRO)
end
function c70219023.fusfilter2(c)
	return c:IsFusionType(TYPE_XYZ)
end
function c70219023.fusfilter3(c)
	return c:IsFusionType(TYPE_LINK)
end
function c70219023.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c70219023.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY+CATEGORY_ATKCHANGE+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,70219023)
	e1:SetTarget(c70219023.target)
	e1:SetOperation(c70219023.operation)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function c70219023.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c70219023.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)>=2000 end
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(70219023,0))
end
function c70219023.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLP(tp)<2000 then return end
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c70219023.thfilter),tp,LOCATION_GRAVE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,3,nil)
	local b3=c:IsRelateToEffect(e) and c:IsFaceup()
	local pay=0
	if b1 then pay=pay+2000 end
	if b2 and Duel.GetLP(tp)-pay>=2000 then pay=pay+2000 end
	if b3 and Duel.GetLP(tp)-pay>=2000 then pay=pay+2000 end
	if pay<2000 then return end
	local m=math.floor(pay/2000)
	local t={}
	for i=1,m do
		t[i]=i*2000
	end
	local ac=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,ac)
	if Duel.GetLP(tp)<=0 then return end
	m=math.floor(ac/2000)
	local g=nil
	if b1 and (m>2 or (m>1 and not (b2 and b3)) or m>0 and (not (b2 or b3) or Duel.SelectYesNo(tp,aux.Stringid(70219023,1)))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c70219023.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		m=m-1
	end
	if b2 and (m>1 or m>0 and (not b3 or Duel.SelectYesNo(tp,aux.Stringid(70219023,2)))) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,3,3,nil)
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
		m=m-1
	end
	if b3 and m>0 then
		Duel.BreakEffect()
		local atk=math.floor(math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp))/2)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD)
		e0:SetCode(EFFECT_CANNOT_ATTACK)
		e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e0:SetTargetRange(LOCATION_MZONE,0)
		e0:SetTarget(c70219023.ftarget)
		e0:SetLabel(c:GetFieldID())
		e0:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e0,tp)
	end
end
function c70219023.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
