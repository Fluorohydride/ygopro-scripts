--百景戦都ゴルディロックス
function c24521754.initial_effect(c)
	--self destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c24521754.descon)
	e1:SetOperation(c24521754.desop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c24521754.atkcon)
	e3:SetValue(3000)
	c:RegisterEffect(e3)
	--move
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(24521754,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c24521754.seqcon)
	e4:SetTarget(c24521754.seqtg)
	e4:SetOperation(c24521754.seqop)
	c:RegisterEffect(e4)
end
function c24521754.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()~=2
end
function c24521754.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c24521754.atkcon(e)
	return e:GetHandler():GetSequence()==2
end
function c24521754.seqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()<5
end
function c24521754.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local fd=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	Duel.Hint(HINT_ZONE,tp,fd)
	local seq=math.log(fd,2)
	e:SetLabel(seq)
	local pseq=c:GetSequence()
	if pseq>seq then pseq,seq=seq,pseq end
	local dg=Group.CreateGroup()
	local g=nil
	local exg=nil
	for i=pseq,seq do
		g=Duel.GetMatchingGroup(c24521754.seqfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c,tp,i)
		dg:Merge(g)
		if i==1 or i==3 then
			exg=Duel.GetMatchingGroup(c24521754.exfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c,tp,i)
			dg:Merge(exg)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function c24521754.seqfilter(c,tp,seq)
	if c:IsControler(tp) then
		return c:GetSequence()==seq
	else
		return c:GetSequence()==4-seq
	end
end
function c24521754.exfilter(c,tp,seq)
	if seq==1 then seq=5 end
	if seq==3 then seq=6 end
	if c:IsControler(tp) then
		return c:GetSequence()==seq
	else
		return c:GetSequence()==11-seq
	end
end
function c24521754.seqop(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetLabel()
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or not c:IsControler(tp) or not Duel.CheckLocation(tp,LOCATION_MZONE,seq) then return end
	local pseq=c:GetSequence()
	if pseq>4 then return end
	Duel.MoveSequence(c,seq)
	if c:GetSequence()==seq then
		if pseq>seq then pseq,seq=seq,pseq end
		local dg=Group.CreateGroup()
		local g=nil
		local exg=nil
		for i=pseq,seq do
			g=Duel.GetMatchingGroup(c24521754.seqfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c,tp,i)
			dg:Merge(g)
			if i==1 or i==3 then
				exg=Duel.GetMatchingGroup(c24521754.exfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c,tp,i)
				dg:Merge(exg)
			end
		end
		if dg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end
