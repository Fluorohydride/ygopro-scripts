--レッド・デーモンズ・ドラゴン・タイラント
function c16172067.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.synlimit)
	c:RegisterEffect(e0)
	--synchro summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c16172067.syncon)
	e1:SetOperation(c16172067.synop)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,16172067)
	e2:SetCondition(c16172067.descon)
	e2:SetTarget(c16172067.destg)
	e2:SetOperation(c16172067.desop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,16172068)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(c16172067.discon)
	e3:SetTarget(c16172067.distg)
	e3:SetOperation(c16172067.disop)
	c:RegisterEffect(e3)
	--double tuner
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(21142671)
	c:RegisterEffect(e4)
end
function c16172067.matfilter1(c,syncard)
	return c:IsType(TYPE_TUNER) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsCanBeSynchroMaterial(syncard)
end
function c16172067.matfilter2(c,syncard)
	return c:IsNotTuner() and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsCanBeSynchroMaterial(syncard)
end
function c16172067.synfilter1(c,syncard,lv,g1,g2,g3,g4,mc)
	if c==mc then return false end
	local f1=c.tuner_filter
	if mc and f1 and not f1(mc) then return false end
	if c:IsHasEffect(EFFECT_HAND_SYNCHRO) then
		return g3:IsExists(c16172067.synfilter2,1,c,syncard,lv,g2,g4,f1,c,mc)
	else
		return g1:IsExists(c16172067.synfilter2,1,c,syncard,lv,g2,g4,f1,c,mc)
	end
end
function c16172067.synfilter2(c,syncard,lv,g2,g4,f1,tuner1,mc)
	if c==tuner1 or c==mc then return false end
	local f2=c.tuner_filter
	if f1 and not f1(c) then return false end
	if f2 and not f2(tuner1) then return false end
	if mc and f2 and not f2(mc) then return false end
	if (tuner1:IsHasEffect(EFFECT_HAND_SYNCHRO) and not c:IsLocation(LOCATION_HAND)) or c:IsHasEffect(EFFECT_HAND_SYNCHRO) then
		return g4:IsExists(c16172067.synfilter3,1,nil,syncard,lv,f1,f2,g2,tuner1,c,mc)
	else
		local mg=g2:Filter(c16172067.synfilter4,nil,f1,f2)
		if not mc then
			Duel.SetSelectedCard(Group.FromCards(c,tuner1))
			return mg:CheckWithSumEqual(Card.GetSynchroLevel,lv,1,99,syncard)
		else
			Duel.SetSelectedCard(Group.FromCards(c,tuner1,mc))
			return mg:CheckWithSumEqual(Card.GetSynchroLevel,lv,0,99,syncard)
		end
	end
end
function c16172067.synfilter3(c,syncard,lv,f1,f2,g2,tuner1,tuner2,mc)
	if c==tuner1 or c==tuner2 or c==mc then return false end
	if (f1 and not f1(c)) or (f2 and not f2(c)) then return false end
	local mg=g2:Filter(c16172067.synfilter4,nil,f1,f2)
	if not mc then
		Duel.SetSelectedCard(Group.FromCards(c,tuner1,tuner2))
	else
		Duel.SetSelectedCard(Group.FromCards(c,tuner1,tuner2,mc))
	end
	return mg:CheckWithSumEqual(Card.GetSynchroLevel,lv,0,99,syncard)
end
function c16172067.synfilter4(c,f1,f2)
	return (not f1 or f1(c)) and (not f2 or f2(c))
end
function c16172067.syncon(e,c,tuner,mg)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-2 then return false end
	if tuner and not tuner:IsCanBeSynchroMaterial(c) then return false end
	local g1=nil
	local g2=nil
	local g3=nil
	local g4=nil
	if mg then
		g1=mg:Filter(c16172067.matfilter1,nil,c)
		g2=mg:Filter(c16172067.matfilter2,nil,c)
		g3=g1:Clone()
		g4=g2:Clone()
	else
		g1=Duel.GetMatchingGroup(c16172067.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g2=Duel.GetMatchingGroup(c16172067.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g3=Duel.GetMatchingGroup(c16172067.matfilter1,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
		g4=Duel.GetMatchingGroup(c16172067.matfilter2,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
	end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	if tuner and tuner:IsType(TYPE_TUNER) then
		local f1=tuner.tuner_filter
		if not pe then
			return g1:IsExists(c16172067.synfilter2,1,tuner,c,lv,g2,g4,f1,tuner)
		else
			return c16172067.synfilter2(pe:GetOwner(),c,lv,g2,nil,f1,tuner)
		end
	end
	if not pe then
		return g1:IsExists(c16172067.synfilter1,1,nil,c,lv,g1,g2,g3,g4,tuner)
	else
		return c16172067.synfilter1(pe:GetOwner(),c,lv,g1,g2,g3,g4,tuner)
	end
end
function c16172067.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner,mg)
	local g=Group.CreateGroup()
	local g1=nil
	local g2=nil
	local g3=nil
	local g4=nil
	if mg then
		g1=mg:Filter(c16172067.matfilter1,nil,c)
		g2=mg:Filter(c16172067.matfilter2,nil,c)
		g3=g1:Clone()
		g4=g2:Clone()
	else
		g1=Duel.GetMatchingGroup(c16172067.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g2=Duel.GetMatchingGroup(c16172067.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g3=Duel.GetMatchingGroup(c16172067.matfilter1,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
		g4=Duel.GetMatchingGroup(c16172067.matfilter2,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
	end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	if tuner and tuner:IsType(TYPE_TUNER) then
		g:AddCard(tuner)
		local f1=tuner.tuner_filter
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tuner2=nil
		if not pe then
			local t2=g1:FilterSelect(tp,c16172067.synfilter2,1,1,tuner,c,lv,g2,g4,f1,tuner)
			tuner2=t2:GetFirst()
		else
			tuner2=pe:GetOwner()
			Group.FromCards(tuner2):Select(tp,1,1,nil)
		end
		g:AddCard(tuner2)
		local f2=tuner2.tuner_filter
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		if tuner2:IsHasEffect(EFFECT_HAND_SYNCHRO) then
			local m3=g4:FilterSelect(tp,c16172067.synfilter3,1,1,nil,c,lv,f1,f2,g2,tuner,tuner2)
			g:Merge(m3)
			local mg2=g2:Filter(c16172067.synfilter4,nil,f1,f2)
			Duel.SetSelectedCard(g)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
			local m4=mg2:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv,0,99,c)
			g:Merge(m4)
		else
			local mg2=g2:Filter(c16172067.synfilter4,nil,f1,f2)
			Duel.SetSelectedCard(g)
			local m3=mg2:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv,1,99,c)
			g:Merge(m3)
		end
	else
		if tuner then g:AddCard(tuner) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tuner1=nil
		if not pe then
			local t1=g1:FilterSelect(tp,c16172067.synfilter1,1,1,nil,c,lv,g1,g2,g3,g4,tuner)
			tuner1=t1:GetFirst()
		else
			tuner1=pe:GetOwner()
			Group.FromCards(tuner1):Select(tp,1,1,nil)
		end
		g:AddCard(tuner1)
		local f1=tuner1.tuner_filter
		local tuner2=nil
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		if tuner1:IsHasEffect(EFFECT_HAND_SYNCHRO) then
			local t2=g3:FilterSelect(tp,c16172067.synfilter2,1,1,tuner1,c,lv,g2,g4,f1,tuner1,tuner)
			tuner2=t2:GetFirst()
		else
			local t2=g1:FilterSelect(tp,c16172067.synfilter2,1,1,tuner1,c,lv,g2,g4,f1,tuner1,tuner)
			tuner2=t2:GetFirst()
		end
		g:AddCard(tuner2)
		local f2=tuner2.tuner_filter
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		if (tuner1:IsHasEffect(EFFECT_HAND_SYNCHRO) and not tuner2:IsLocation(LOCATION_HAND))
			or tuner2:IsHasEffect(EFFECT_HAND_SYNCHRO) then
			local m3=g4:FilterSelect(tp,c16172067.synfilter3,1,1,nil,c,lv,f1,f2,g2,tuner1,tuner2,tuner)
			g:Merge(m3)
			local mg2=g2:Filter(c16172067.synfilter4,nil,f1,f2)
			Duel.SetSelectedCard(g)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
			local m4=mg2:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv,0,99,c)
			g:Merge(m4)
		else
			local mg2=g2:Filter(c16172067.synfilter4,nil,f1,f2)
			Duel.SetSelectedCard(g)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
			if not tuner then
				local m3=mg2:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv,1,99,c)
				g:Merge(m3)
			else
				local m3=mg2:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv,0,99,c)
				g:Merge(m3)
			end
		end
	end
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
end
function c16172067.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c16172067.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c16172067.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c16172067.ftarget)
	e1:SetLabel(e:GetHandler():GetFieldID())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c16172067.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function c16172067.discon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and Duel.IsChainNegatable(ev) and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end
function c16172067.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c16172067.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
		if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e1:SetValue(500)
		c:RegisterEffect(e1)
	end
end
